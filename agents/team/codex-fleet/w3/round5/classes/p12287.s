# n=5 model=out iset=I1 prefix14_class=12287
mov S0, P2
cmp P0, S0
cmovl P2, P0
mov S2, P2
cmovge S0, P0
cmp P1, P3
cmovge P0, P3
cmovg P3, P1
cmovg P1, P0
cmp P2, P1
cmovge S2, P1
cmovge P1, P2
cmp P3, S0
cmovle S2, P3
