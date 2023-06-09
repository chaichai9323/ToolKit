#!/usr/bin/ruby 

script = 'branchName=`git rev-parse --abbrev-ref HEAD`
productBranch=false
if [ $branchName == master ] || [ $branchName == main ]; then
    productBranch=true
    echo "当前在[master/main]分支"
else
    echo "当前在[$branchName]分支"
fi
if [ $productBranch == true ]; then
    echo "准备开始校验环境"
    if [[ $SWIFT_ACTIVE_COMPILATION_CONDITIONS =~ "AppStoreEnv" ]]; then
        echo "校验环境通过"
    else
        echo "error:校验环境不通过，请检查配置"
        exit 1
    fi
fi'

script2='googlepath=""
for f in `find $SRCROOT -name "GoogleService-Info*.plist"`; do
  content=`grep -E "test-project.*\.appspot\.com" $f`
  if [[ $content == *appspot* ]]; then
    continue
  else
    googlepath=$f
    break
  fi
done
branchName=`git rev-parse --abbrev-ref HEAD`
if [ $branchName == master ] || [ $branchName == main ]; then
  if [[ ${#googlepath} > 0 ]]; then
    echo "找到正式服:"$googlepath
    dstPath=$TARGET_BUILD_DIR/$TARGET_NAME.app/GoogleService-Info.plist
    cp -f $googlepath $dstPath
  else
    echo "error:没有找到正式服GoogleInfo"
    exit 1
  fi
fi
'
script_phase :name => 'verifyAppStoreEnv', :script => "#{script}", :execution_position => :before_compile
script_phase :name => 'verifyGoogleInfo', :script => "#{script2}", :execution_position => :after_compile

branchName = `git rev-parse --abbrev-ref HEAD`.gsub(/\s+/, '')
condition = ""
if branchName == "master" || branchName == "main"
  condition = "AppStoreEnv"
else
  condition = "DevelopEnv"
end

post_integrate do |installer|
  installer.generated_aggregate_targets.each do |target|
    Dir.glob("Pods/**/*#{target.name}*.xcconfig").each do | fold |
      if "#{fold}".downcase.end_with?(".debug.xcconfig")
        condition = "DevelopEnv"
      end
      content = File.read("#{fold}").gsub!(/(SWIFT_ACTIVE_COMPILATION_CONDITIONS){1}\W*=/,"\\1 = $(inherited) #{condition} ")
      if content == nil
        str = "SWIFT_ACTIVE_COMPILATION_CONDITIONS = $(inherited) #{condition}"
        File.open("#{fold}", "a") do |file|
          file.write(str)
        end
      else
        File.write("#{fold}", content)    
      end
    end
  end
end  
