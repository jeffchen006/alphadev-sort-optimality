# n=5 model=out iset=I1 prefix14_class=10914
mov S0, P1
cmp P0, P1
cmovle P1, P0
cmovg S0, P0
mov P0, P3
cmp P0, P2
cmovle P0, P2
cmovl P2, P3
cmp P0, S0
cmovle P3, P0
cmovle P0, S0
cmovle S0, P3
cmp P1, P2
cmovle P3, P2
