# n=5 model=out iset=I1 prefix14_class=12265
cmp P1, P0
mov S0, P0
cmovge P0, P1
cmovl S0, P1
cmp P2, P3
cmovge P1, P3
cmovg P3, P2
mov S1, S0
cmovge P2, P1
cmp S0, P2
cmovle S0, P2
cmovge S1, P2
mov S1, P0
cmovg P2, S0
