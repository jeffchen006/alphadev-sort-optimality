# n=5 model=out iset=I1 prefix14_class=9586
cmp P0, P3
mov S1, P2
cmovle S0, P0
cmovl P0, P3
cmovle P3, S0
cmp P1, S1
cmovg S1, P1
cmovge P1, P2
cmp P0, S1
cmovl P2, P0
cmovge P2, S1
cmovg S1, P0
cmp P3, P1
mov S1, P2
