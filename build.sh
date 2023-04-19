echo "Enter your commit message"
read message

echo "Building your app"

flutter build apk --split-per-abi

mkdir -p ./gen/

mv ./build/app/outputs/flutter-apk/*.apk ./gen/


git add .
git commit -m "$message"
git push origin main