String getId(String from) =>
    from == null ? '' : from.replaceAll(' ', '_').toLowerCase();
