import ICRC7 "mo:icrc7-mo";
import Principal "mo:base/Principal";

module{
  public let defaultConfig = func(caller: Principal) : ICRC7.InitArgs{
      ?{
        symbol = ?"SST";
        name = ?"Town Story Game Account Pass - Starship Ticket ICP";
        description = ?"A Collection of Town Story Galaxy，The Starship Ticket is the account pass used in Town Story Galaxy.";
        logo = ?"https://townstory.io/nft/ticket/logo.png";
        supply_cap = null;
        allow_transfers = null;
        max_query_batch_size = ?100;
        max_update_batch_size = ?100;
        default_take_value = ?1000;
        max_take_value = ?10000;
        max_memo_size = ?512;
        permitted_drift = null;
        tx_window = null;
        burn_account = null; //burned nfts are deleted
        deployer = Principal.fromText("");
        supported_standards = null;
      };
  };
};