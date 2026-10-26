# n=5 model=out iset=I1 prefix14_class=10422
mov S0, P1
cmp S0, P2
cmovle S0, P2
cmovge P1, P2
mov P2, P3
cmp P0, P2
cmovg P3, P0
cmovl P2, P0
cmp S0, P3
mov S2, P2
cmovg P0, S0
cmovge S0, P3
mov S1, S0
cmovg P3, P0
