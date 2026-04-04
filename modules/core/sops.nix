{...}: {
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets.sshAuthorizedKey = {neededForUsers = true;};
    secrets.githubSshKey = {
      path = "/home/tiizzel/.ssh/id_ed25519";
      owner = "tiizzel";
      mode = "0600";
    };
  };
}
