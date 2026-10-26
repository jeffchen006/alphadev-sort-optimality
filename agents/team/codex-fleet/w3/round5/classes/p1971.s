# n=5 model=out iset=I1 prefix14_class=1971
cmp P2, P1
cmovle S0, P2
cmovge S0, P1
mov S2, P0
cmovle P2, P1
cmp P3, S2
cmovle P0, P3
cmovg S2, P3
mov P3, P2
cmp P2, S2
cmovl P2, S2
cmovle S2, P3
cmp P0, S0
cmovle P1, P0
