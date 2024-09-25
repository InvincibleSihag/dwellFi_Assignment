def get_ip_and_mac_addresses():
    """
    Gets the IP and MAC addresses of all active network interfaces.
    and processes for the local ip address and corresponding mac address
    Returns:
        list: A dictionary, each containing 'ip' and 'mac' keys.
    """
    import netifaces
    interfaces = netifaces.interfaces()
    addresses = []
    ip_mac = {}
    print("starting : ", netifaces.AF_INET)
    for interface in interfaces:
        if netifaces.AF_INET in netifaces.ifaddresses(interface):
            ipv4 = netifaces.ifaddresses(interface)
            mac = netifaces.ifaddresses(interface)
            print(ipv4)
            # print(mac)
            addresses.append({'ip': ipv4, 'mac': mac})
    return addresses

print(get_ip_and_mac_addresses())