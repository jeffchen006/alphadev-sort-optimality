# n=5 model=out iset=I1 prefix14_class=12112
mov S1, P0
cmp P1, P0
cmovle S1, P1
cmovle P1, P0
cmp P3, P2
cmovle P0, P3
cmovl P3, P2
cmovle P2, P0
cmp P2, S1
cmovg S2, P2
cmovge P2, S1
cmovle S2, S1
cmp P3, P1
cmovge S0, P3
