# n=5 model=out iset=I1 prefix14_class=10364
cmp P0, P2
mov S1, P1
cmovge S0, P2
cmovge P2, P0
cmovge P0, S0
cmp P3, P1
cmovge P1, P3
cmovl S1, P3
cmp P2, P1
cmovg S2, P1
cmovge P1, P2
cmovle S2, P2
cmp P0, S1
cmovle P2, S1
