#include "components/firmwarevalidator/FirmwareValidator.h"

#include <hal/nrf_rtc.h>
#include "drivers/InternalFlash.h"
#include "target.h"

using namespace Pinetime::Controllers;

bool FirmwareValidator::IsValidated() const {
  auto* boot_flags = reinterpret_cast<uint32_t*>(WOLFBOOT_PARTITION_BOOT_ADDRESS + WOLFBOOT_PARTITION_SIZE - 8);
  const uint32_t boot_success = 0x00FFFFFF;
  return (*boot_flags) == boot_success;
}

void FirmwareValidator::Validate() {
  if (!IsValidated()) {
      auto boot_flags = (WOLFBOOT_PARTITION_BOOT_ADDRESS + WOLFBOOT_PARTITION_SIZE - 8);
      const uint32_t boot_success = 0x00FFFFFF;
      Pinetime::Drivers::InternalFlash::WriteWord(boot_flags, boot_success);
  }
}

void FirmwareValidator::Reset() {
  NVIC_SystemReset();
}
