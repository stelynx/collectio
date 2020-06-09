/// Generates Collection id from its title.
String getId(String from) =>
    from == null ? '' : from.replaceAll(' ', '_').toLowerCase();
