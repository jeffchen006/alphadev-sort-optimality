# n=5 model=out iset=I1 prefix14_class=11361
mov S0, P3
cmp P0, S0
cmovl P3, P0
cmovl P0, S0
cmp P2, P1
cmovle S0, P2
cmovl P2, P1
cmovg S0, P1
cmp P2, P0
cmovge S1, P0
cmovg P0, P2
cmovge P2, S1
mov P0, S0
cmp S0, P3
