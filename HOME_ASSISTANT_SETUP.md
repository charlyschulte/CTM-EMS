# CTM-EMS Home Assistant Add-on

To set up this project as a Home Assistant add-on, you need to follow these steps:

## Add the Repository to Home Assistant

1. Navigate to your Home Assistant instance.
2. Go to Settings → Add-ons → Add-on Store.
3. Click on the menu in the top right corner (three dots).
4. Select "Repositories".
5. Add the following URL: `https://github.com/charlyschulte/CTM-EMS`
6. Click "Add".
7. The repository should now appear in your add-on store.

## Add-on Structure

Your add-on directory should have this structure:
```
ctm-ems/
  ├── Dockerfile
  ├── config.yaml
  ├── build.yaml
  ├── run.sh
  ├── README.md (copied from ADDON.md)
  ├── package.json
  ├── tsconfig.json
  ├── bun.lockb
  ├── index.ts
  └── src/
      ├── commands/
      ├── config/
      ├── models/
      ├── services/
      └── utils/
```

## Testing Your Add-on

1. In Home Assistant, navigate to the Add-on Store
2. Click the refresh button at the top right
3. You should see your add-on listed under "Local add-ons"
4. Install and start the add-on
5. Check the logs to ensure everything is working correctly

## Notes

- The SQLite database will be stored in the persistent `/data` directory
- The Tibber API key is configured through the add-on configuration page
- If you make changes to your code, you'll need to update the version number in `config.yaml` to see the update in Home Assistant

## Debugging

If your add-on doesn't appear in the store:
1. Check for YAML syntax errors in your `config.yaml`
2. Check the Supervisor logs for error messages
3. Ensure all required files have the correct permissions
