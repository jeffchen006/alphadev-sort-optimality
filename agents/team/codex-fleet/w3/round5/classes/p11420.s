# n=5 model=out iset=I1 prefix14_class=11420
mov S0, P1
cmp P0, S0
cmovle S0, P0
cmovl P0, P1
cmp P3, P2
cmovge S2, P3
cmovge P3, P2
mov P1, P3
cmovg P2, S2
cmp P3, S0
cmovl P1, S0
cmovg P3, S0
mov P3, P2
cmp P3, P0
