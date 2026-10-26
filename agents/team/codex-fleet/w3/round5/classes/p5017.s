# n=5 model=out iset=I1 prefix14_class=5017
mov S0, P3
cmp P0, P3
cmovle S0, P0
cmovge P3, P0
mov S1, P2
cmp S1, P1
cmovle P2, P1
cmovg S1, P1
cmp S0, S1
cmovle P1, S1
cmovle S1, S0
cmovge P1, S0
cmp P2, P3
cmovl S1, P2
