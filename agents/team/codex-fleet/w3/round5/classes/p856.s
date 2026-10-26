# n=5 model=out iset=I1 prefix14_class=856
mov S0, P3
mov S1, P1
cmp S0, P0
cmovl S0, P0
cmovg P3, P0
cmp S1, P2
cmovg S1, P2
cmovge P2, P1
mov P0, S0
cmp P2, P0
cmovge P0, P2
cmovle S0, P2
mov S2, S1
cmovge P2, S0
