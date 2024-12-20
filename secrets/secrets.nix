let
  wsl_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGAHcqar+k/8/K1bSQ3TqZtenUSZjW9lWWA4lfx1oSM";
  nixos_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAqIyRbxrEAWwXj40Ie8DGeqDeLHKlDCkMhLmFs/y3KoXKiLj42e/JOIeE+as0P7xDG4KZY4nf8LjxL4V2TsnHSACLa6lewG4Gs6scrZdn0iI6Z2oHOAknLnzObiga62ux6FxnZ0QvRI8Nf132B50l78TGNi/kXRuS8PoiXWLw5HeXseDV4PK4gzRQEObbDZkMv+gY0jNuQJHM5lHbNjx1OM9rMDyzB8CwAC5AL2O2Y9hVDNgeXAlLRULd3mJNEwYFjN9mKp5Wq6g2K7Cs2fZlG4L4svLK/dQOKnngpPOtIEzj4fxzd6t+gTEMOWsFp7Kv+CA1CjE6RWmMMzUFAyCH10LgJ+wdXNo+plktPik2Vrmh35i/EBkBDDh8qUEo6I6DQC2scdM9Qr8bEULkfM+ODV5PnxUIuuIT83AnyZ0qAPaHcbRLspm374vrg4MoWZBp+P15AMc795wa3OxdidUvgA6UX5Ndp3IlOiG3flkhGqukEgJjBSNGbGQ2UW0r9i73lxGmcLfT8k+gC6a9EgJYbO6yFwtsUYqh5aVIdn68Xcbn/Ym6iUfzDIv7hXa0dgykPap6V1LWo/K7ABd/8GQDhzM7IRUAjNKy28b2aymUjsMNTFeZme/c0w+gNAWrzYaHwfmk7bJYfl88fEkPn1dkxqjLO4d6dmUZnygvXZIgtQ==";
  macos_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDP1/hugnFNYgsLlRa48BUTUsJToJFxdXyOx9ePBECY63hXzJmQWOKivnhNqF0V39Dy67wfnqxOdmZXgAyIKGwPuSvkzhLLc+f6g9Akaadt5q9GCXsShE7gwaHOp5Xw6mT0+r/9NzXA1CiGsIpdXZjpPrp0uDD7FK1R+9TvZAsG61UeF9wc5rE359Eie3xWaj/XltE9kAPoXqFZw+YSsmb3zWAmQhXcmBo7v27shG1UzKgcCXr0GXMYcd+JfHUyiq4GuQfOlOaS3pUvm53U2O0uCpQ76L57KFiT9wLK4ry0Hflu2/x3BnWUk6fAEZ9+847sisbUv160j0Ayhn1W4cPB";
in
{
  "github-token.age".publicKeys = [
    wsl_key
    nixos_key
    macos_key
  ];
  "password.age".publicKeys = [
    nixos_key
  ];
  "wgProton.age".publicKeys = [
    nixos_key
  ];
}
