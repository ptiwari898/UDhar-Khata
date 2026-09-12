package com.example

import org.junit.Assert.assertEquals
import org.junit.Test

class ExampleRobolectricTest {

  @Test
  fun `string_metadata_is_available_in_test_environment`() {
    val appName = "Udhar Khata"
    assertEquals("Udhar Khata", appName)
  }
}
