# n=5 model=out iset=I1 prefix14_class=10961
mov S0, P2
cmp P2, P0
cmovle P2, P0
cmovl P0, S0
cmp P3, P1
cmovge S1, P3
cmovge P3, P1
cmovg P1, S1
cmp P1, P2
cmovle S0, P1
cmovg S0, P2
cmovge P2, P1
cmp P0, P3
cmovle P1, P3
