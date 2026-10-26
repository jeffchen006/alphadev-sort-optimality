# n=5 model=out iset=I1 prefix14_class=14418
mov S1, P0
cmp P1, S1
mov S0, P3
cmovle S1, P1
cmovle P1, P0
cmp S0, P2
cmovl S0, P2
cmovle P2, P3
cmp P2, S1
cmovg P3, P2
cmovg P2, S1
cmovg S1, P3
cmp P1, S0
cmovge P0, P1
