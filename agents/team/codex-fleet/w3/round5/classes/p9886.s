# n=5 model=out iset=I1 prefix14_class=9886
cmp P0, P3
mov S2, P0
cmovg S2, P3
cmovge P3, P0
mov S1, P1
cmp P1, P2
cmovle P1, P2
cmovl P2, S1
cmp P3, P1
cmovge S0, P1
cmovg P1, P3
cmovle S0, P3
cmp P2, S2
cmovle S1, P2
