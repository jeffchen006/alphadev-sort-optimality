# n=5 model=out iset=I1 prefix14_class=13020
cmp P3, P0
mov S1, P3
cmovg S1, P0
cmovle P3, P0
mov S2, P2
cmp P1, P2
cmovge P2, P1
cmovg P1, S2
cmp S1, P1
cmovle S2, S1
cmovl S1, P1
mov S0, P2
cmovle P1, S2
cmp P3, S0
