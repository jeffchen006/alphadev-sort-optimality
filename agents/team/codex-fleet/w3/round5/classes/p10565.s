# n=5 model=out iset=I1 prefix14_class=10565
cmp P2, P3
cmovle S2, P3
cmovg S2, P2
cmovle P3, P2
cmp P0, P1
cmovge P2, P1
cmovg P1, P0
cmovge P0, P2
mov S0, S2
cmp S2, P1
cmovl S2, P1
cmovge S0, P1
mov S1, P3
mov P1, S0
