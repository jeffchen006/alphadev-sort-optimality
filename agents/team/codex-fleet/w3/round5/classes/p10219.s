# n=5 model=out iset=I1 prefix14_class=10219
cmp P0, P2
mov S0, P3
cmovle S2, P0
cmovl P0, P2
cmovl P2, S2
cmp P1, S0
cmovg S0, P1
cmovge P1, P3
mov P3, S0
cmp P0, P3
cmovle S0, P0
cmovg P3, P0
cmp P2, P1
cmovge P0, S0
