# n=5 model=out iset=I1 prefix14_class=13194
mov S0, P0
cmp P2, P0
cmovle S0, P2
cmovg P0, P2
cmp P3, P1
cmovle P2, P3
mov S1, S0
cmovle P3, P1
cmovle P1, P2
cmp S1, P1
cmovg S1, P1
cmovl S0, P1
cmp P3, P0
cmovge P2, P3
