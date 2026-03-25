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
    # Убиваем при 10% RAM чтобы успеть до заморозки системы.
    # Swap — при 25%: когда swap близок к нулю, система уже не отвечает.
    freeMemThreshold = 10;
    freeSwapThreshold = 25;
    enableNotifications = true;
    extraArgs = [
      "--prefer" "(Isolated Web Co|slack|Telegram|java)"
      # Сообщать о состоянии памяти каждые 30 секунд (для диагностики)
      "--memory-report-interval" "30"
    ];
  };

  # Ядерный OOM killer: убивать процесс который исчерпал память,
  # а не случайный. Работает как последний рубеж обороны.
  boot.kernel.sysctl = {
    "vm.oom_kill_allocating_task" = 1;
  };
}
