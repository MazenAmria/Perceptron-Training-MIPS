  .globl mul_matrix
mul_matrix:
  # Multiplies a matrix to another (element wise)
  # Aij *= Bij
  # $a0: address of the destination matrix (ixj size)
  # $a1: address of the source matrix (ixj size)
  # $a2: i (4-bytes integer)
  # $a3: j (4-bytes integer)
    
  addiu $sp, $sp, -28
  sw $ra, 8($sp)
  sw $fp, 4($sp)
  move $fp, $sp
  sw $a0, 12($fp)                           # save A
  sw $a1, 16($fp)                           # save B
  sw $a2, 20($fp)                           # save i
  sw $a3, 24($fp)                           # save j
  sw $zero, 0($fp)                          # unsigned int _i = 0
  j mul_matrix_i_check

mul_matrix_i_body:

  lw $t0, 0($fp)                            # load _i
  sll $t0, $t0, 2                           # convert to byte offset
  lw $t1, 12($fp)                           # load A
  addu $t0, $t1, $t0                        # calculate the address
  lw $a0, 0($t0)                            # pass A[_i]

  lw $t0, 0($fp)                            # load _i
  sll $t0, $t0, 2                           # convert to byte offset
  lw $t1, 16($fp)                           # load B
  addu $t0, $t1, $t0                        # calculate the address
  lw $a1, 0($t0)                            # pass B[_i]

  lw $a2, 24($fp)                           # pass j

  jal mul_vector

  lw $t0, 0($fp)
  addiu $t0, $t0, 1
  sw $t0, 0($fp)                            # _i++

mul_matrix_i_check:

  lw $t1, 0($fp)                            # load _i
  lw $t0, 20($fp)                           # load i
  sltu $t0, $t1, $t0                        # if _i < i
  bne $t0, $zero, mul_matrix_i_body         # continue
  # else
  move $sp, $fp
  lw $ra, 8($sp)
  lw $fp, 4($sp)
  addiu $sp, $sp, 28                        # free the stack
  jr $ra                                    # return

