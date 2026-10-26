# n=5 model=out iset=I1 prefix14_class=6757
cmp P1, P3
cmovle S0, P1
cmovg S0, P3
cmovle P1, P3
mov S2, P0
cmp S2, P2
cmovl S2, P2
cmovg P0, P2
cmp P1, S2
cmovg P2, P1
cmovge P1, S2
cmovg S2, P2
cmp S0, P0
cmovle P2, P0
