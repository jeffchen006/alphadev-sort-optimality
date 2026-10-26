# n=5 model=out iset=I1 prefix14_class=8416
mov S1, P2
cmp S1, P1
cmovg S1, P1
mov S0, P0
cmovge P1, P2
cmp P3, P0
cmovg P0, P3
cmovl S0, P3
cmp P1, P0
cmovge P3, P0
cmovg P0, P1
mov P0, S0
cmovge P1, P3
cmp S1, P0
