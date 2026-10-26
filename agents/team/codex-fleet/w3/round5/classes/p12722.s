# n=5 model=out iset=I1 prefix14_class=12722
mov S0, P2
cmp P2, P0
cmovge S0, P0
cmovle P2, P0
cmp P1, P3
cmovle S2, P1
cmovl P1, P3
cmovle P3, S2
cmp P3, S0
cmovle S1, S0
cmovg S1, P3
cmovge P3, S0
cmp P1, P2
cmovge S0, P1
