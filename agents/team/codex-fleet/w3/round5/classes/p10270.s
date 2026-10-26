# n=5 model=out iset=I1 prefix14_class=10270
mov S0, P1
mov S1, P3
cmp P2, S1
cmovg P3, P2
cmovle S1, P2
cmp P1, P0
cmovl S0, P0
cmovge P1, P0
cmp S0, P3
cmovge P0, P3
cmovge P3, S0
cmovge S0, P0
mov P2, S0
cmp S1, P1
