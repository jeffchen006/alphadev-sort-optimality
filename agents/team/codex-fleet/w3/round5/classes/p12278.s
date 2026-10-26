# n=5 model=out iset=I1 prefix14_class=12278
mov S2, P0
cmp P2, P0
cmovle S2, P2
cmovge P0, P2
cmp P3, P1
cmovge P2, P1
cmovg P1, P3
mov S0, S2
cmovg P3, P2
cmp S2, P3
cmovge S0, P3
cmovg P3, S2
cmp P1, P0
cmovl P2, P0
