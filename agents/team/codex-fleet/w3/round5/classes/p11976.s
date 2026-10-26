# n=5 model=out iset=I1 prefix14_class=11976
mov S1, P1
cmp P2, S1
cmovge P1, P2
cmovge P2, S1
cmp P3, P0
cmovle S2, P3
cmovle P3, P0
cmovl P0, S2
mov S0, P2
mov S1, P1
cmp P0, S0
cmovle S0, P0
cmovle P0, P2
cmovge P2, P0
