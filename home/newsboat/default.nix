{...}: {
  programs.newsboat = {
    enable = true;

    queries = {
      "YouTube" = ''(rssurl =~ "youtube")'';
      "Audio" = ''(tags # "audio")'';
      "YouTube (edu)" = ''(rssurl =~ "youtube") and (tags # "edu")'';
      "YouTube (tech)" = ''(rssurl =~ "youtube") and (tags # "tech")'';
      "YouTube (fun)" = ''(rssurl =~ "youtube") and (tags # "fun")'';
    };
    urls = import ./urls.nix;

    autoReload = true;
    reloadThreads = 64;
    extraConfig = ''
      article-sort-order date-desc
      scrolloff 5

      bind-key j down
      bind-key k up
      bind-key J next-feed
      bind-key K prev-feed

      bind-key h quit
      bind-key l open
      bind-key L open-in-browser

      bind-key g home
      bind-key G end
      bind-key s sort
      bind-key S rev-sort
    '';
  };
}
