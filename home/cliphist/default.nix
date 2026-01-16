{...}: {
  services.cliphist = {
    enable = true;
    allowImages = true;
    extraOptions = [
      "-max-items"
      "1500"
    ];
  };
}
