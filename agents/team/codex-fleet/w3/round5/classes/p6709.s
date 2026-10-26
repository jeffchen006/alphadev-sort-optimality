# n=5 model=out iset=I1 prefix14_class=6709
cmp P1, P3
mov S1, P1
cmovle S1, P3
cmovge P1, P3
cmp P2, P0
cmovge P3, P2
cmovle P3, P0
cmovle P0, P2
cmp P3, S1
mov S0, P3
cmovl S0, S1
cmovle S1, P3
cmp P1, P0
cmovge P2, P0
