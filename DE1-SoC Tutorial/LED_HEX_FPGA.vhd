-----------------------------
-- HED_LED_FPGA Tutorial
-- Lab 3
-- COE838 Systems-on-Chip Design
-- Created By: Anita Tino
-----------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY LED_HEX_FPGA IS
PORT(
    -- Clock and HPS Interface
    CLOCK_50, HPS_DDR3_RZQ, HPS_ENET_RX_CLK, HPS_ENET_RX_DV : IN STD_LOGIC;
    HPS_DDR3_ADDR : OUT STD_LOGIC_VECTOR(14 DOWNTO 0);
    HPS_DDR3_BA : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    HPS_DDR3_CS_N : OUT STD_LOGIC;
    HPS_DDR3_CK_P, HPS_DDR3_CK_N, HPS_DDR3_CKE : OUT STD_LOGIC;
    HPS_USB_DIR, HPS_USB_NXT, HPS_USB_CLKOUT : IN STD_LOGIC;
    HPS_ENET_RX_DATA : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    HPS_SD_DATA, HPS_DDR3_DQS_N : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    HPS_DDR3_DQS_P : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    HPS_ENET_MDIO : INOUT STD_LOGIC;
    HPS_USB_DATA : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    HPS_DDR3_DQ : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    HPS_SD_CMD : INOUT STD_LOGIC;
    HPS_ENET_TX_DATA, HPS_DDR3_DM : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    HPS_DDR3_ODT, HPS_DDR3_RAS_N, HPS_DDR3_RESET_N : OUT STD_LOGIC;
    HPS_DDR3_CAS_N, HPS_DDR3_WE_N : OUT STD_LOGIC;
    HPS_ENET_MDC, HPS_ENET_TX_EN : OUT STD_LOGIC;

    -- LED and HEX Display Outputs
    LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0);

    -- Switch Inputs
    SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);  -- Added switches as input

    -- Additional HPS Interface Signals
    HPS_USB_STP, HPS_SD_CLK, HPS_ENET_GTX_CLK : OUT STD_LOGIC
);
END LED_HEX_FPGA;

ARCHITECTURE Behaviour OF LED_HEX_FPGA IS
    -- Component declaration for the soc_system
    component soc_system is
        port (
            -- Clock and Reset
            clk_clk : in std_logic := 'X';
            reset_reset_n : in std_logic := 'X';

            -- HPS Memory Interface
            memory_mem_a : out std_logic_vector(14 downto 0);
            memory_mem_ba : out std_logic_vector(2 downto 0);
            memory_mem_ck : out std_logic;
            memory_mem_ck_n : out std_logic;
            memory_mem_cke : out std_logic;
            memory_mem_cs_n : out std_logic;
            memory_mem_ras_n : out std_logic;
            memory_mem_cas_n : out std_logic;
            memory_mem_we_n : out std_logic;
            memory_mem_reset_n : out std_logic;
            memory_mem_dq : inout std_logic_vector(31 downto 0) := (others => 'X');
            memory_mem_dqs : inout std_logic_vector(3 downto 0) := (others => 'X');
            memory_mem_dqs_n : inout std_logic_vector(3 downto 0) := (others => 'X');
            memory_mem_odt : out std_logic;
            memory_mem_dm : out std_logic_vector(3 downto 0);
            memory_oct_rzqin : in std_logic := 'X';

            -- HPS I/O Interface
            hps_io_hps_io_emac1_inst_TX_CLK : out std_logic;
            hps_io_hps_io_emac1_inst_TXD0 : out std_logic;
            hps_io_hps_io_emac1_inst_TXD1 : out std_logic;
            hps_io_hps_io_emac1_inst_TXD2 : out std_logic;
            hps_io_hps_io_emac1_inst_TXD3 : out std_logic;
            hps_io_hps_io_emac1_inst_RXD0 : in std_logic := 'X';
            hps_io_hps_io_emac1_inst_MDIO : inout std_logic := 'X';
            hps_io_hps_io_emac1_inst_MDC : out std_logic;
            hps_io_hps_io_emac1_inst_RX_CTL : in std_logic := 'X';
            hps_io_hps_io_emac1_inst_TX_CTL : out std_logic;
            hps_io_hps_io_emac1_inst_RX_CLK : in std_logic := 'X';
            hps_io_hps_io_emac1_inst_RXD1 : in std_logic := 'X';
            hps_io_hps_io_emac1_inst_RXD2 : in std_logic := 'X';
            hps_io_hps_io_emac1_inst_RXD3 : in std_logic := 'X';
            hps_io_hps_io_sdio_inst_CMD : inout std_logic := 'X';
            hps_io_hps_io_sdio_inst_D0 : inout std_logic := 'X';
            hps_io_hps_io_sdio_inst_D1 : inout std_logic := 'X';
            hps_io_hps_io_sdio_inst_CLK : out std_logic;
            hps_io_hps_io_sdio_inst_D2 : inout std_logic := 'X';
            hps_io_hps_io_sdio_inst_D3 : inout std_logic := 'X';
            hps_io_hps_io_usb1_inst_D0 : inout std_logic := 'X';
            hps_io_hps_io_usb1_inst_D1 : inout std_logic := 'X';
            hps_io_hps_io_usb1_inst_D2 : inout std_logic := 'X';
            hps_io_hps_io_usb1_inst_D3 : inout std_logic := 'X';
            hps_io_hps_io_usb1_inst_D4 : inout std_logic := 'X';
            hps_io_hps_io_usb1_inst_D5 : inout std_logic := 'X';
            hps_io_hps_io_usb1_inst_D6 : inout std_logic := 'X';
            hps_io_hps_io_usb1_inst_D7 : inout std_logic := 'X';
            hps_io_hps_io_usb1_inst_CLK : in std_logic := 'X';
            hps_io_hps_io_usb1_inst_STP : out std_logic;
            hps_io_hps_io_usb1_inst_DIR : in std_logic := 'X';
            hps_io_hps_io_usb1_inst_NXT : in std_logic := 'X';

            -- LED and Switch PIOs
            led_pio_external_connection_export : out std_logic_vector(9 downto 0);
            switch_pio_external_connection_export : in std_logic_vector(9 downto 0);  -- Added switch PIO

            -- HEX Display Interface
            seg7_if_0_conduit_end_export : out std_logic_vector(47 downto 0)
        );
    end component soc_system;

    -- Internal signals
    SIGNAL hex5_tmp, hex4_tmp, hex3_tmp, hex2_tmp, hex1_tmp, hex0_tmp, hps_0_h2f_reset_reset_n : STD_LOGIC;

BEGIN
    -- Instantiate the soc_system component
    u0 : component soc_system
        port map (
            -- Clock and Reset
            clk_clk => CLOCK_50,
            reset_reset_n => '1',

            -- HPS Memory Interface
            memory_mem_a => HPS_DDR3_ADDR,
            memory_mem_ba => HPS_DDR3_BA,
            memory_mem_ck => HPS_DDR3_CK_P,
            memory_mem_ck_n => HPS_DDR3_CK_N,
            memory_mem_cke => HPS_DDR3_CKE,
            memory_mem_cs_n => HPS_DDR3_CS_N,
            memory_mem_ras_n => HPS_DDR3_RAS_N,
            memory_mem_cas_n => HPS_DDR3_CAS_N,
            memory_mem_we_n => HPS_DDR3_WE_N,
            memory_mem_reset_n => HPS_DDR3_RESET_N,
            memory_mem_dq => HPS_DDR3_DQ,
            memory_mem_dqs => HPS_DDR3_DQS_P,
            memory_mem_dqs_n => HPS_DDR3_DQS_N,
            memory_mem_odt => HPS_DDR3_ODT,
            memory_mem_dm => HPS_DDR3_DM,
            memory_oct_rzqin => HPS_DDR3_RZQ,

            -- HPS I/O Interface
            hps_io_hps_io_emac1_inst_TX_CLK => HPS_ENET_GTX_CLK,
            hps_io_hps_io_emac1_inst_TXD0 => HPS_ENET_TX_DATA(0),
            hps_io_hps_io_emac1_inst_TXD1 => HPS_ENET_TX_DATA(1),
            hps_io_hps_io_emac1_inst_TXD2 => HPS_ENET_TX_DATA(2),
            hps_io_hps_io_emac1_inst_TXD3 => HPS_ENET_TX_DATA(3),
            hps_io_hps_io_emac1_inst_RXD0 => HPS_ENET_RX_DATA(0),
            hps_io_hps_io_emac1_inst_MDIO => HPS_ENET_MDIO,
            hps_io_hps_io_emac1_inst_MDC => HPS_ENET_MDC,
            hps_io_hps_io_emac1_inst_RX_CTL => HPS_ENET_RX_DV,
            hps_io_hps_io_emac1_inst_TX_CTL => HPS_ENET_TX_EN,
            hps_io_hps_io_emac1_inst_RX_CLK => HPS_ENET_RX_CLK,
            hps_io_hps_io_emac1_inst_RXD1 => HPS_ENET_RX_DATA(1),
            hps_io_hps_io_emac1_inst_RXD2 => HPS_ENET_RX_DATA(2),
            hps_io_hps_io_emac1_inst_RXD3 => HPS_ENET_RX_DATA(3),
            hps_io_hps_io_sdio_inst_CMD => HPS_SD_CMD,
            hps_io_hps_io_sdio_inst_D0 => HPS_SD_DATA(0),
            hps_io_hps_io_sdio_inst_D1 => HPS_SD_DATA(1),
            hps_io_hps_io_sdio_inst_CLK => HPS_SD_CLK,
            hps_io_hps_io_sdio_inst_D2 => HPS_SD_DATA(2),
            hps_io_hps_io_sdio_inst_D3 => HPS_SD_DATA(3),
            hps_io_hps_io_usb1_inst_D0 => HPS_USB_DATA(0),
            hps_io_hps_io_usb1_inst_D1 => HPS_USB_DATA(1),
            hps_io_hps_io_usb1_inst_D2 => HPS_USB_DATA(2),
            hps_io_hps_io_usb1_inst_D3 => HPS_USB_DATA(3),
            hps_io_hps_io_usb1_inst_D4 => HPS_USB_DATA(4),
            hps_io_hps_io_usb1_inst_D5 => HPS_USB_DATA(5),
            hps_io_hps_io_usb1_inst_D6 => HPS_USB_DATA(6),
            hps_io_hps_io_usb1_inst_D7 => HPS_USB_DATA(7),
            hps_io_hps_io_usb1_inst_CLK => HPS_USB_CLKOUT,
            hps_io_hps_io_usb1_inst_STP => HPS_USB_STP,
            hps_io_hps_io_usb1_inst_DIR => HPS_USB_DIR,
            hps_io_hps_io_usb1_inst_NXT => HPS_USB_NXT,

            -- LED and Switch PIOs
            led_pio_external_connection_export => LEDR,
            switch_pio_external_connection_export => SW,  -- Connected switches

            -- HEX Display Interface
            seg7_if_0_conduit_end_export(47) => hex5_tmp,
            seg7_if_0_conduit_end_export(46 DOWNTO 40) => HEX5,
            seg7_if_0_conduit_end_export(39) => hex4_tmp,
            seg7_if_0_conduit_end_export(38 DOWNTO 32) => HEX4,
            seg7_if_0_conduit_end_export(31) => hex3_tmp,
            seg7_if_0_conduit_end_export(30 DOWNTO 24) => HEX3,
            seg7_if_0_conduit_end_export(23) => hex2_tmp,
            seg7_if_0_conduit_end_export(22 DOWNTO 16) => HEX2,
            seg7_if_0_conduit_end_export(15) => hex1_tmp,
            seg7_if_0_conduit_end_export(14 DOWNTO 8) => HEX1,
            seg7_if_0_conduit_end_export(7) => hex0_tmp,
            seg7_if_0_conduit_end_export(6 DOWNTO 0) => HEX0
        );
END Behaviour;
