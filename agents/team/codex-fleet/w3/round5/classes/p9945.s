# n=5 model=out iset=I1 prefix14_class=9945
cmp P2, P3
cmovg S0, P2
cmovle S0, P3
cmovle P3, P2
cmp P0, P1
cmovge P2, P0
cmovge P0, P1
mov S1, S0
cmovge P1, P2
cmp S0, P1
cmovl S1, P1
cmovg S0, P1
mov S1, P0
cmp S1, P3
