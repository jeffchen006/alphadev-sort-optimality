# n=5 model=out iset=I1 prefix14_class=5886
mov S2, P0
cmp P1, P0
cmovg P0, P1
mov S0, P2
cmovg P1, S2
cmp P3, P2
cmovle S0, P3
cmovle P3, P2
cmp P3, P0
mov S1, P0
cmovge P0, P3
cmovl S1, P3
cmp S0, P1
cmovle P3, S0
