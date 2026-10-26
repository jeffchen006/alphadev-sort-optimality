# n=5 model=out iset=I1 prefix14_class=567
cmp P3, P1
cmovge S2, P3
cmovg P3, P1
cmovg P1, S2
cmp P2, P0
mov S0, P2
cmovge P2, P0
cmovle S0, P0
mov P0, P3
cmp P2, P0
cmovge P3, P2
cmovl P0, P2
mov P2, S0
cmp P1, S0
