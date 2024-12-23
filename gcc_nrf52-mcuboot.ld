/****************************************************************
 * Memory map configuration for using application with MCU-boot *
 ****************************************************************/
/*
 * Internal nRF52 flash memory:
 * 0x00000000: MCUBoot(28 kB)
 * 0x00007000: Reboot logs (4 kB)
 * 0x00008000: MCUBoot header (32 bytes)
 * 0x00008020: Application (463+ kB)
 * 0x0007be50: MCUBoot image trailer (432 bytes)
 * 0x0007c000: MCUBoot Scratch partition (4 kB)
 * 0x0007d000: unused (12 kB)
 *
 * SPI flash:
 * 0x00000000: Bootloader Assets, like Boot Graphic (256 kB)
 * 0x00040000: Application 2 (including MCUBoot header) (464 kB)
 * 0x000b4000: User files - littlefs (3376 kB)
 */

SEARCH_DIR(.)
GROUP(-lgcc -lc -lnosys)

WOLFBOOT_SIZE = 0x8000;
IMAGE_HEADER_SIZE = 0x400;
SCRATCH_OFFSET = 0x7c000;
SPARE_OFFSET = 0x7d000;
APP_OFFSET = WOLFBOOT_SIZE + IMAGE_HEADER_SIZE;
APP_SIZE = 464K; /* Fixed */


MEMORY
{
  FLASH (rx) : ORIGIN = APP_OFFSET, LENGTH = APP_SIZE
  SPARE_SPACE (r) : ORIGIN = SPARE_OFFSET, LENGTH = 12K
  RAM (rwx) :  ORIGIN = 0x20000000, LENGTH = 64K
}

SECTIONS
{
  .noinit(NOLOAD):
  {
    PROVIDE(__start_noinit_data = .);
    *(.noinit)
    PROVIDE(__stop_noinit_data = .);
  } > RAM
} INSERT AFTER .bss

SECTIONS
{
  . = ALIGN(4);
  .mem_section_dummy_ram :
  {
  }
  .cli_sorted_cmd_ptrs :
  {
    PROVIDE(__start_cli_sorted_cmd_ptrs = .);
    KEEP(*(.cli_sorted_cmd_ptrs))
    PROVIDE(__stop_cli_sorted_cmd_ptrs = .);
  } > RAM
  .fs_data :
  {
    PROVIDE(__start_fs_data = .);
    KEEP(*(.fs_data))
    PROVIDE(__stop_fs_data = .);
  } > RAM
  .log_dynamic_data :
  {
    PROVIDE(__start_log_dynamic_data = .);
    KEEP(*(SORT(.log_dynamic_data*)))
    PROVIDE(__stop_log_dynamic_data = .);
  } > RAM
  .log_filter_data :
  {
    PROVIDE(__start_log_filter_data = .);
    KEEP(*(SORT(.log_filter_data*)))
    PROVIDE(__stop_log_filter_data = .);
  } > RAM

} INSERT AFTER .data;

SECTIONS
{
  .mem_section_dummy_rom :
  {
  }
  .sdh_soc_observers :
  {
    PROVIDE(__start_sdh_soc_observers = .);
    KEEP(*(SORT(.sdh_soc_observers*)))
    PROVIDE(__stop_sdh_soc_observers = .);
  } > FLASH
  .sdh_ble_observers :
  {
    PROVIDE(__start_sdh_ble_observers = .);
    KEEP(*(SORT(.sdh_ble_observers*)))
    PROVIDE(__stop_sdh_ble_observers = .);
  } > FLASH
  .sdh_req_observers :
  {
    PROVIDE(__start_sdh_req_observers = .);
    KEEP(*(SORT(.sdh_req_observers*)))
    PROVIDE(__stop_sdh_req_observers = .);
  } > FLASH
  .sdh_state_observers :
  {
    PROVIDE(__start_sdh_state_observers = .);
    KEEP(*(SORT(.sdh_state_observers*)))
    PROVIDE(__stop_sdh_state_observers = .);
  } > FLASH
  .sdh_stack_observers :
  {
    PROVIDE(__start_sdh_stack_observers = .);
    KEEP(*(SORT(.sdh_stack_observers*)))
    PROVIDE(__stop_sdh_stack_observers = .);
  } > FLASH
    .nrf_queue :
  {
    PROVIDE(__start_nrf_queue = .);
    KEEP(*(.nrf_queue))
    PROVIDE(__stop_nrf_queue = .);
  } > FLASH
    .nrf_balloc :
  {
    PROVIDE(__start_nrf_balloc = .);
    KEEP(*(.nrf_balloc))
    PROVIDE(__stop_nrf_balloc = .);
  } > FLASH
    .cli_command :
  {
    PROVIDE(__start_cli_command = .);
    KEEP(*(.cli_command))
    PROVIDE(__stop_cli_command = .);
  } > FLASH
  .crypto_data :
  {
    PROVIDE(__start_crypto_data = .);
    KEEP(*(SORT(.crypto_data*)))
    PROVIDE(__stop_crypto_data = .);
  } > FLASH
  .pwr_mgmt_data :
  {
    PROVIDE(__start_pwr_mgmt_data = .);
    KEEP(*(SORT(.pwr_mgmt_data*)))
    PROVIDE(__stop_pwr_mgmt_data = .);
  } > FLASH
  .log_const_data :
  {
    PROVIDE(__start_log_const_data = .);
    KEEP(*(SORT(.log_const_data*)))
    PROVIDE(__stop_log_const_data = .);
  } > FLASH
  .log_backends :
  {
    PROVIDE(__start_log_backends = .);
    KEEP(*(SORT(.log_backends*)))
    PROVIDE(__stop_log_backends = .);
  } > FLASH
    .nrf_balloc :
  {
    PROVIDE(__start_nrf_balloc = .);
    KEEP(*(.nrf_balloc))
    PROVIDE(__stop_nrf_balloc = .);
  } > FLASH

} INSERT AFTER .text


INCLUDE "./nrf_common.ld"
