# n=5 model=out iset=I1 prefix14_class=4242
cmp P3, P1
mov S2, P1
cmovge P1, P3
cmovg P3, S2
mov S0, P0
cmp P2, P0
cmovge S0, P2
cmovge P2, P0
cmp P3, P2
mov S1, P3
cmovle S1, P2
cmovl P2, P3
cmp S0, P1
mov P2, P1
