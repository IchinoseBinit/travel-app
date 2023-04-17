echo "Enter your commit message"
read message

echo "Building your app"

flutter build apk --no-tree-shake-icons --release --split-per-abi

mkdir -p ./gen/

mv ./build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk ./gen/TwoPointO.apk


git add .
git commit -m "$message"
git push origin main