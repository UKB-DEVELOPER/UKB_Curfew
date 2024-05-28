Notify = {}

Notify.NotifyClient = function(type, message)
   pcall(function()
        exports.nc_notify:PushNotification({
            title = 'ระบบ',
            description = message,
            icon = 'default',
            type = type,
            duration = 4000
        })
   end)
end