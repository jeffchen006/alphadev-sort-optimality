# n=5 model=out iset=I1 prefix14_class=9433
mov S0, P3
cmp P1, S0
cmovle S0, P1
cmovl P1, P3
cmp P0, P2
cmovg P3, P0
cmovg P0, P2
cmovle P3, P2
cmp P0, S0
mov P2, S0
cmovl P2, P0
cmovg S0, P0
cmp P1, P3
cmovge P0, S0
