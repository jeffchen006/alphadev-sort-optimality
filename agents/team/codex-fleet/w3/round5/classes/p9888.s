# n=5 model=out iset=I1 prefix14_class=9888
mov S0, P1
cmp P1, P0
cmovge P1, P0
cmovge P0, S0
cmp P2, P3
cmovg S1, P2
cmovle S1, P3
cmovle P3, P2
cmp P0, S1
cmovle S0, S1
cmovl S1, P0
cmovle P0, S0
cmp P3, P1
cmovle P2, P3
