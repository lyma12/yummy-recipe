echo "------------------------------------------------------------"
echo "🔥🔥🔥 Pulling dependencies..."
echo "------------------------------------------------------------"
fvm flutter pub get

echo "------------------------------------------------------------"
echo "🔥🔥🔥 Generating all files..."
echo "------------------------------------------------------------"
fvm flutter pub run build_runner build --delete-conflicting-outputs

