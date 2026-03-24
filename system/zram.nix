{ pkgs, ... }:

{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    swapDevices = 1;
    memoryPercent = 50;
  };

  hardware.ksm.enable = true;

  # Убивает прожорливые процессы до того как система зависает.
  # Срабатывает когда свободной памяти < 5% или свободного swap < 10%.
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
    # Уведомление на рабочий стол при срабатывании
    enableNotifications = true;
    extraArgs = [
      # Firefox вкладки (Isolated Web Co[ntent]) → Slack → Telegram → java
      "--prefer" "(Isolated Web Co|slack|Telegram|java)"
    ];
  };
}
