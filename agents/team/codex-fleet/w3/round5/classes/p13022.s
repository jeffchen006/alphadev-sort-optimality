# n=5 model=out iset=I1 prefix14_class=13022
mov S1, P3
cmp P3, P0
cmovg S1, P0
cmovle P3, P0
mov S0, P1
cmp P2, S0
cmovge P1, P2
cmovge P2, S0
mov S2, P2
cmp P2, S1
cmovl P2, S1
cmovle S1, S2
cmp P1, P3
cmovg S2, P3
