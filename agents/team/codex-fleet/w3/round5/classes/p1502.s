# n=5 model=out iset=I1 prefix14_class=1502
mov S1, P1
mov S0, P2
cmp P1, P3
cmovle S1, P3
cmovg P1, P3
cmp P2, P0
cmovl S0, P0
cmovle P0, P2
cmp S0, S1
cmovge P3, S1
cmovg S1, S0
mov P2, P1
cmovg S0, P3
cmp P0, P1
